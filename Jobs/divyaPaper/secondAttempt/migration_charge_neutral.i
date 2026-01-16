[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 40
  xmin = 0.0
  xmax = 1.0
[]

# -------------------------------------------------
# Variables
# -------------------------------------------------
[Variables]
  [./c_plus]
    family = LAGRANGE
    order = FIRST
    initial_condition = 1.0
  [../]
[]

# Anion is NOT solved for
[AuxVariables]
  [./c_minus]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

# -------------------------------------------------
# External electric potential (keep weak for now)
# -------------------------------------------------
[Functions]
  [./phi_ext]
    type = ParsedFunction
    expression = '-E*x'
    symbol_names = 'E'
    symbol_values = '0.1'
  [../]
[]

# -------------------------------------------------
# Materials
# -------------------------------------------------
[Materials]
  [./mobility_plus]
    type = IonicMobilityMaterial
    D = 1.0
    z = 1.0
    T = 1.0
    property_name = mobility_plus
  [../]
[]

# -------------------------------------------------
# Kernels (ONLY for c_plus)
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

  [./migration]
    type = ADMigration
    variable = c_plus
    c = c_plus
    mobility = mobility_plus
    electric_potential = phi_ext
  [../]

[]

# -------------------------------------------------
# AuxKernel enforcing charge neutrality
# -------------------------------------------------
[AuxKernels]
  [./anion_balance]
    type = ChargeNeutralAux
    variable = c_minus
    c_plus = c_plus
    z_plus = 1
    z_minus = -1
  [../]
[]

# -------------------------------------------------
# Executioner
# -------------------------------------------------
[Executioner]
  type = Transient
  scheme = implicit-euler

  dt = 1e-3
  end_time = 0.05

  solve_type = NEWTON
  line_search = basic

  nl_max_its = 15
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8
[]

# -------------------------------------------------
# Output
# -------------------------------------------------
[Outputs]
  exodus = true
[]
