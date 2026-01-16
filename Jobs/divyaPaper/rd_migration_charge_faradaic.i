# ============================================================
# Mesh
# ============================================================
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 200
  ny = 40
  xmin = 0.0
  xmax = 5e-5        # 50 micron
  ymin = 0.0
  ymax = 1e-5
  boundary_id   = '0 1 2 3'
  boundary_name = 'left right bottom top'
[]

# ============================================================
# Functions
# ============================================================
[Functions]

  # External electric potential
  [./phi_ext]
    type = ParsedFunction
    expression = '-E*x'
    symbol_names = 'E'
    symbol_values = '1e4'    # 10 kV/m
  [../]

  # Smoothly ramped current density (A/m^2)
  # j(t) = j0 * (1 - exp(-t/tau))
[./j_app]
  type = ParsedFunction
  expression = '-j0*(1 - exp(-t/tau))/(2*96485)'
  symbol_names = 'j0 tau'
  symbol_values = '100 0.05'
[../]

[]

# ============================================================
# Variables
# ============================================================
[Variables]

  [./K]
    initial_condition = 100
  [../]

  [./H]
    initial_condition = 1.4e-4
  [../]

  [./CO3]
    initial_condition = 0.039
  [../]

  [./CO2]
    initial_condition = 34.061
  [../]

[]

# ============================================================
# Aux variables (electroneutrality)
# ============================================================
[AuxVariables]

  [./HCO3]
    family = MONOMIAL
    order = CONSTANT
  [../]

  [./HCO3_dev]
    family = MONOMIAL
    order = CONSTANT
  [../]

[]

# ============================================================
# Materials
# ============================================================
[Materials]

  [./mobility_K]
    type = IonicMobilityMaterial
    D = 1.96e-9
    z = 1
    T = 298
    property_name = mu_K
  [../]

  [./mobility_H]
    type = IonicMobilityMaterial
    D = 9.31e-9
    z = 1
    T = 298
    property_name = mu_H
  [../]

  [./mobility_CO3]
    type = IonicMobilityMaterial
    D = 0.92e-9
    z = -2
    T = 298
    property_name = mu_CO3
  [../]

[]

# ============================================================
# Kernels
# ============================================================
[Kernels]

  # ---------- K+ ----------
  [./time_K]
    type = TimeDerivative
    variable = K
  [../]

  [./diff_K]
    type = Diffusion
    variable = K
  [../]

  [./mig_K]
    type = ADMigration
    variable = K
    c = K
    mobility = mu_K
    electric_potential = phi_ext
  [../]

  # ---------- H+ ----------
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

  # ---------- CO3^2- ----------
  [./time_CO3]
    type = TimeDerivative
    variable = CO3
  [../]

  [./diff_CO3]
    type = Diffusion
    variable = CO3
  [../]

  [./mig_CO3]
    type = ADMigration
    variable = CO3
    c = CO3
    mobility = mu_CO3
    electric_potential = phi_ext
  [../]

  # ---------- CO2 ----------
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
# Electroneutrality constraint
# ============================================================
[AuxKernels]

  [./neutrality]
    type = ChargeNeutralMultiAux
    variable = HCO3
    species = 'K H CO3'
    charges = '1 1 -2'
    z_target = -1
  [../]

  [./HCO3_dev]
    type = ParsedAux
    variable = HCO3_dev
    coupled_variables = 'K H CO3 HCO3'
    expression = 'K + H - 2*CO3 - HCO3'
  [../]

[]

# ============================================================
# Boundary Conditions (Faradaic flux)
# ============================================================
[BCs]

  # CO2 consumption: CO2 + 2e-
  [./CO2_faradaic]
    type = FunctionNeumannBC
    variable = CO2
    boundary = left
    function = j_app
  [../]

  # Proton generation
  [./H_faradaic]
    type = FunctionNeumannBC
    variable = H
    boundary = left
    function = j_app
  [../]

  # Bulk CO2 reservoir
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

  dt = 1e-2
  dtmin = 1e-8
  dtmax = 0.1

  end_time = 0.5

  solve_type = NEWTON
  line_search = basic

  nl_max_its = 40
  nl_rel_tol = 1e-4
  nl_abs_tol = 1e-6
[]


# ============================================================
# Output
# ============================================================
[Outputs]
  exodus = true
[]
