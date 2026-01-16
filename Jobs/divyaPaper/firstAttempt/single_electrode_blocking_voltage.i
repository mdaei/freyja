# ==========================================
# Single blocking electrode
# GMPNP + Poisson
# Adaptive transient voltage ramp
# ==========================================

[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 100
  xmin = 0.0
  xmax = 2e-7
[]

# ------------------------------------------
# Primary variables
# ------------------------------------------
[Variables]

  [./phi]
    order = FIRST
    family = LAGRANGE
  [../]

  [./c_plus]
    order = FIRST
    family = LAGRANGE
  [../]

  [./c_minus]
    order = FIRST
    family = LAGRANGE
  [../]

[]

# ------------------------------------------
# Initial conditions (electroneutral bulk)
# ------------------------------------------
[ICs]

  [./phi_ic]
    type = ConstantIC
    variable = phi
    value = 0.0
  [../]

  [./c_plus_ic]
    type = ConstantIC
    variable = c_plus
    value = 1000.0
  [../]

  [./c_minus_ic]
    type = ConstantIC
    variable = c_minus
    value = 1000.0
  [../]

[]

# ------------------------------------------
# Kernels
# ------------------------------------------
[Kernels]

  [./phi_poisson]
    type = ADPoissonChargeKernel
    variable = phi
    concentrations = 'c_plus c_minus'
    z = '1 -1'
  [../]

  [./c_plus_gmpnp]
    type = ADGMPNPKernel
    variable = c_plus
    z = 1
    D = 1e-9
    T = 298
    ai3 = 1e-28
    phi = phi
    concentrations = 'c_plus c_minus'
  [../]

  [./c_minus_gmpnp]
    type = ADGMPNPKernel
    variable = c_minus
    z = -1
    D = 1e-9
    T = 298
    ai3 = 1e-28
    phi = phi
    concentrations = 'c_plus c_minus'
  [../]

[]

# ------------------------------------------
# Auxiliary variables
# ------------------------------------------
[AuxVariables]
  [./charge_density]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxKernels]
  [./charge_density_aux]
    type = ChargeDensityAux
    variable = charge_density
    c_plus = c_plus
    c_minus = c_minus
  [../]
[]

# ------------------------------------------
# Voltage ramp (continuation parameter)
# ------------------------------------------
[Functions]
  [./voltage_ramp]
    type = PiecewiseLinear
    x = '0      1e-10   1e-7'
    y = '0      0       0.01'
  [../]
[]

# ------------------------------------------
# Boundary conditions
# ------------------------------------------
[BCs]

  # Blocking electrode with applied voltage
  [./phi_left]
    type = FunctionDirichletBC
    variable = phi
    boundary = left
    function = voltage_ramp
  [../]

  # Ground reference
  [./phi_right]
    type = DirichletBC
    variable = phi
    boundary = right
    value = 0.0
  [../]

  # Blocking ions
  [./c_plus_blocked]
    type = ADNeumannBC
    variable = c_plus
    boundary = left
    value = 0.0
  [../]

  [./c_minus_blocked]
    type = ADNeumannBC
    variable = c_minus
    boundary = left
    value = 0.0
  [../]

[]

# ------------------------------------------
# Executioner (THIS is the key change)
# ------------------------------------------
[Executioner]
  type = Transient
  scheme = implicit-euler

  dt = 1e-15
  dtmin = 1e-18
  dtmax = 1e-10
  end_time = 1e-7

  nl_rel_tol = 1e-9
  nl_abs_tol = 1e-12
  nl_max_its = 40
[]

[TimeStepper]
  type = IterationAdaptiveDT
  optimal_iterations = 8
  growth_factor = 1.5
  cutback_factor = 0.3
[]


# ------------------------------------------
# Outputs
# ------------------------------------------
[Outputs]
  exodus = true
[]
