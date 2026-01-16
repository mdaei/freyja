
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 20
  xmin = 0.0
  xmax = 5e-5        # 50 micron domain
  ymin = 0.0
  ymax = 1e-5        # 10 micron domain
  boundary_id   = '0 1 2 3'
  boundary_name = 'left right bottom top'
[]

# -------------------------------------------------
# Initial condition for K+
# -------------------------------------------------
[Functions]
  [./phi_ext]
    type = ParsedFunction
    expression = '-E*x'
    symbol_names = 'E'
    symbol_values = '10e4'   # 10 kV/m
  [../]

  [./CO2_reaction_flux]
    type = ParsedFunction
    expression = '-k*c'
    symbol_names = 'k c'
    symbol_values = '1e-4 1.0'
  [../]
[]


# -------------------------------------------------
# Variables (solved)
# -------------------------------------------------
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
# Materials: physical diffusivities & mobilities
# -------------------------------------------------
[Materials]

  [./mobility_K]
    type = IonicMobilityMaterial
    D = 1.96e-9      # m^2/s
    z = 1.0
    T = 298
    property_name = mu_K
  [../]

  [./mobility_H]
    type = IonicMobilityMaterial
    D = 9.31e-9      # m^2/s
    z = 1.0
    T = 298
    property_name = mu_H
  [../]

  [./mobility_CO3]
    type = IonicMobilityMaterial
    D = 0.92e-9      # m^2/s
    z = -2.0
    T = 298
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

[BCs]

  [./CO2_cathode]
    type = NeumannBC
    variable = CO2
    boundary = left
    value = '5e-5'
  [../]

  [./CO3_cathode]
    type = NeumannBC
    variable = CO3
    boundary = left
    value = '5e-5'
  [../]
 [./K_bulk]
    type = DirichletBC
    variable = K
    boundary = right
    value = 100
  [../]

  [./H_bulk]
    type = DirichletBC
    variable = H
    boundary = right
    value = 1.4e-4
  [../]

  [./CO3_bulk]
    type = DirichletBC
    variable = CO3
    boundary = right
    value = 0.039
  [../]

  [./CO2_bulk]
    type = DirichletBC
    variable = CO2
    boundary = right
    value = 34.061
  [../]
[]
# -------------------------------------------------
# Diagnostics
# -------------------------------------------------
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
# Executioner
# -------------------------------------------------
[Executioner]
  type = Transient
  scheme = implicit-euler

  dt = 1e-2          # appropriate for 50 micron
  end_time = 5.0

  solve_type = NEWTON
  line_search = basic

  nl_max_its = 20
  nl_rel_tol = 1e-4
  nl_abs_tol = 1e-6
[]

# -------------------------------------------------
# Output
# -------------------------------------------------
[Outputs]
  exodus = true
[]
