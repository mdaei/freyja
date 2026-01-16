[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 100
  xmin = 0.0
  xmax = 1.0
[]

[Functions]
  [./K_ic]
    type = ParsedFunction
    expression = '100 + 10*sin(pi*x)'
  [../]
[]
[ICs]
  [./K_ic]
    type = FunctionIC
    variable = K
    function = K_ic
  [../]
[]

# -------------------------------------------------
# Variables (solved)
# -------------------------------------------------
[Variables]

  [./K]
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

# -------------------------------------------------
# Eliminated species
# -------------------------------------------------
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

# -------------------------------------------------
# External electric potential (start weak!)
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
# Materials: mobilities
# -------------------------------------------------
[Materials]

  [./mobility_K]
    type = IonicMobilityMaterial
    D = 1.0
    z = 1.0
    T = 1.0
    property_name = mu_K
  [../]

  [./mobility_H]
    type = IonicMobilityMaterial
    D = 1.0
    z = 1.0
    T = 1.0
    property_name = mu_H
  [../]

  [./mobility_CO3]
    type = IonicMobilityMaterial
    D = 1.0
    z = -2.0
    T = 1.0
    property_name = mu_CO3
  [../]

[]

# -------------------------------------------------
# Kernels
# -------------------------------------------------
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

  # ---------- CO2 (neutral) ----------
  [./time_CO2]
    type = TimeDerivative
    variable = CO2
  [../]

  [./diff_CO2]
    type = Diffusion
    variable = CO2
  [../]

[]

# -------------------------------------------------
# Charge neutrality (algebraic)
# -------------------------------------------------
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
    coupled_variables = 'HCO3 K H CO3'
    expression = 'K + H - 2*CO3 - HCO3'
  [../]
[]

[Postprocessors]
  [./charge_error]
    type = ElementIntegralVariablePostprocessor
    variable = HCO3
  [../]
    [./charge_error_L2]
    type = ElementL2Norm
    variable = HCO3_dev
  [../]
[]

# -------------------------------------------------
# Executioner (robust)
# -------------------------------------------------
[Executioner]
  type = Transient
  scheme = implicit-euler

  dt = 1e-3
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
