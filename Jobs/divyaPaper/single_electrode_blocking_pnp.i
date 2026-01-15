# =========================================
# Stage 2 Diagnostic: Jacobian Singularity
# =========================================

[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 100
  xmin = 0.0
  xmax = 2e-7
[]

# -----------------------------------------
# Variables
# -----------------------------------------
[Variables]
  [./phi]
    family = LAGRANGE
    order = FIRST
  [../]

  [./c_plus]
    family = LAGRANGE
    order = FIRST
  [../]

  [./c_minus]
    family = LAGRANGE
    order = FIRST
  [../]
[]

# -----------------------------------------
# Initial Conditions
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

# -----------------------------------------
# Boundary Conditions
# -----------------------------------------
[BCs]

  # Ground potential to remove Poisson nullspace
  [./phi_ground]
    type = DirichletBC
    variable = phi
    boundary = right
    value = 0.0
  [../]

  # 🚨 DIAGNOSTIC CONSTRAINT
  # Fix anion concentration everywhere
  [./c_minus_fixed]
    type = DirichletBC
    variable = c_minus
    boundary = 'left right'
    value = 1000.0
  [../]

[]

# -----------------------------------------
# Executioner
# -----------------------------------------
[Executioner]
  type = Steady
  solve_type = NEWTON

  nl_abs_tol = 1e-12
  nl_rel_tol = 1e-9
  nl_max_its = 20

  petsc_options_iname = '-snes_linesearch_type'
  petsc_options_value = 'bt'
[]

# -----------------------------------------
# Outputs
# -----------------------------------------
[Outputs]
  exodus = true
[]
