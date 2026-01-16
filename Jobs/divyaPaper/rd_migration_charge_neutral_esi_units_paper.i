# ============================================================
# Paper-faithful carbonate system (equilibrium, electroneutral)
# ============================================================

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 20
  xmin = 0.0
  xmax = 5e-5        # 50 micron
  ymin = 0.0
  ymax = 1e-5
  boundary_id   = '0 1 2 3'
  boundary_name = 'left right bottom top'
[]

# ============================================================
# External electric potential (migration)
# ============================================================
[Functions]
  [./phi_ext]
    type = ParsedFunction
    expression = '-E*x'
    symbol_names = 'E'
    symbol_values = '1e4'   # 10 kV/m
  [../]
[]

# ============================================================
# Primary solved variables
# ============================================================
[Variables]

  # Proton concentration (controls pH)
  [./H]
    initial_condition = 1.4e-4
    scaling = 1e4
  [../]

  # Dissolved CO2
  [./CO2]
    initial_condition = 34.061
  [../]

[]

# ============================================================
# Algebraic (equilibrium) species
# ============================================================
[AuxVariables]

  [./HCO3]
    family = MONOMIAL
    order = CONSTANT
  [../]

  [./CO3]
    family = MONOMIAL
    order = CONSTANT
  [../]

  [./K]
    family = MONOMIAL
    order = CONSTANT
  [../]

[]

# ============================================================
# Physical transport properties
# ============================================================
[Materials]

  [./mobility_H]
    type = IonicMobilityMaterial
    D = 9.31e-9
    z = 1
    T = 298
    property_name = mu_H
  [../]

[]

# ============================================================
# Transport equations
# ============================================================
[Kernels]

  # ---- H+ ----
  [./time_H]
    type = TimeDerivative
    variable = H
  [../]

  [./diff_H]
    type = Diffusion
    variable = H
  [../]

  [./mig_H]
    type = ADMigration
    variable = H
    c = H
    mobility = mu_H
    electric_potential = phi_ext
  [../]

  # ---- CO2 ----
  [./time_CO2]
    type = TimeDerivative
    variable = CO2
  [../]

  [./diff_CO2]
    type = Diffusion
    variable = CO2
  [../]

[]

# ============================================================
# Carbonate equilibrium (from paper)
# ============================================================
[AuxKernels]

  # HCO3- = Ka1 * CO2 / H
  [./HCO3_eq]
    type = ParsedAux
    variable = HCO3
    coupled_variables = 'CO2 H'
    expression = 'Ka1 * CO2 / H'
    constant_names = 'Ka1'
    constant_values = '4.45e-7'
  [../]

  # CO3-- = Ka2 * HCO3 / H
  [./CO3_eq]
    type = ParsedAux
    variable = CO3
    coupled_variables = 'HCO3 H'
    expression = 'Ka2 * HCO3 / H'
    constant_names = 'Ka2'
    constant_values = '4.69e-11'
  [../]

  # Electroneutrality: K+ = HCO3- + 2 CO3-- - H+
  [./K_neutral]
    type = ParsedAux
    variable = K
    coupled_variables = 'H HCO3 CO3'
    expression = 'HCO3 + 2*CO3 - H'
  [../]

[]

# ============================================================
# Boundary conditions
# ============================================================
[BCs]

  # CO2 consumption at electrode
  [./CO2_flux_left]
    type = NeumannBC
    variable = CO2
    boundary = left
    value = -1e-4
  [../]

  # Bulk reservoir
  [./CO2_bulk]
    type = DirichletBC
    variable = CO2
    boundary = right
    value = 34.061
  [../]

[]

# ============================================================
# Executioner
# ============================================================
[Executioner]
  type = Transient
  scheme = implicit-euler

  dt = 1e-3
  end_time = 1.0

  solve_type = NEWTON
  nl_max_its = 20
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8
[]

# ============================================================
# Output
# ============================================================
[Outputs]
  exodus = true
[]
