[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 50
  xmin = 0.0
  xmax = 1.0
[]

# -------------------------------------------------
# Primary variables (only c_plus is solved)
# -------------------------------------------------
[Variables]
  [./c_plus]
    family = LAGRANGE
    order = FIRST
    initial_condition = 1.0
  [../]
[]

# -------------------------------------------------
# Aux variable for eliminated species
# -------------------------------------------------
[AuxVariables]
  [./c_minus]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

# -------------------------------------------------
# Kernels (pure diffusion)
# -------------------------------------------------
[Kernels]

  [./time]
    type = TimeDerivative
    variable = c_plus
  [../]

  [./diff]
    type = Diffusion
    variable = c_plus
  [../]

[]

# -------------------------------------------------
# Charge neutrality constraint
# -------------------------------------------------
[AuxKernels]
  [./charge_neutrality]
    type = ChargeNeutralAux
    variable = c_minus
    c_plus = c_plus
    z_plus = 1
    z_minus = -1
  [../]
[]

# -------------------------------------------------
# Boundary conditions (zero flux)
# -------------------------------------------------
[BCs]
  [./left]
    type = NeumannBC
    variable = c_plus
    value = 0.0
    boundary = left
  [../]

  [./right]
    type = NeumannBC
    variable = c_plus
    value = 0.0
    boundary = right
  [../]
[]

# -------------------------------------------------
# Executioner
# -------------------------------------------------
[Executioner]
  type = Transient
  scheme = implicit-euler

  dt = 1e-2
  end_time = 0.5

  solve_type = NEWTON
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
[]

# -------------------------------------------------
# Output
# -------------------------------------------------
[Outputs]
  exodus = true
[]
