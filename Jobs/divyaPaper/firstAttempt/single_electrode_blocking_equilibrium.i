# =========================================
# Stage 2: Blocking electrode equilibrium
# GMPNP + Poisson (no applied current)
# =========================================

[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 200
  xmin = 0.0
  xmax = 2e-7
[]

# -----------------------------------------
# Primary variables
# -----------------------------------------
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

# -----------------------------------------
# Initial conditions (bulk electroneutral)
# -----------------------------------------
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

# -----------------------------------------
# Kernels
# -----------------------------------------
[Kernels]

  # Poisson equation
  [./phi_poisson]
    type = ADPoissonChargeKernel
    variable = phi
    concentrations = 'c_plus c_minus'
    z = '1 -1'
  [../]

  # Cation GMPNP
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

  # Anion GMPNP
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

# -----------------------------------------
# Auxiliary variables (diagnostics only)
# -----------------------------------------
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

# -----------------------------------------
# Boundary conditions
# -----------------------------------------
[BCs]

  # Blocking electrode at x = 0
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

  # Ground reference potential at bulk
  [./phi_ground]
    type = DirichletBC
    variable = phi
    boundary = right
    value = 0.0
  [../]

[]

# -----------------------------------------
# Executioner
# -----------------------------------------
[Executioner]
  type = Transient
  scheme = implicit-euler

  dt = 1e-11
  dtmin = 1e-14
  end_time = 5e-9

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-11
  nl_max_its = 40
  l_max_its = 200

  petsc_options_iname = '-snes_linesearch_type'
  petsc_options_value = 'bt'
[]

# -----------------------------------------
# Outputs
# -----------------------------------------
[Outputs]
  exodus = true
[]
