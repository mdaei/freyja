[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 20
  xmin = 0.0
  xmax = 1.0
[]

[Variables]
  [./c]
    family = LAGRANGE
    order = FIRST
    initial_condition = 1.0
  [../]
[]

# -------------------------------------------------
# VERY WEAK electric field (key to convergence)
# -------------------------------------------------
[Functions]
  [./phi_ext]
    type = ParsedFunction
    expression = '-E*x'
    symbol_names = 'E'
    symbol_values = '0.01'
  [../]
[]

# -------------------------------------------------
# Materials
# -------------------------------------------------
[Materials]
  [./mobility]
    type = IonicMobilityMaterial
    D = 1.0
    z = 1.0
    T = 1.0
    property_name = mobility
  [../]
[]

# -------------------------------------------------
# Kernels
# -------------------------------------------------
[Kernels]

  [./time]
    type = TimeDerivative
    variable = c
  [../]

  # Unit diffusion only (your MOOSE supports no coeffs)
  [./diff]
    type = Diffusion
    variable = c
  [../]

  [./migration]
    type = ADMigration
    variable = c
    c = c
    mobility = mobility
    electric_potential = phi_ext
  [../]

[]

# -------------------------------------------------
# Executioner (ROBUST SETTINGS)
# -------------------------------------------------
[Executioner]
  type = Transient
  scheme = implicit-euler

  dt = 1e-3
  dtmin = 1e-12
  end_time = 0.05

  solve_type = NEWTON
  line_search = basic

  nl_max_its = 20
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8
[]

# -------------------------------------------------
# Output
# -------------------------------------------------
[Outputs]
  exodus = true
[]
