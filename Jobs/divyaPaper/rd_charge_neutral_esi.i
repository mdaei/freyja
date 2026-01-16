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
# Primary variables (solved)
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
# Kernels (pure diffusion only)
# -------------------------------------------------
[Kernels]

  [./time_K]
    type = TimeDerivative
    variable = K
  [../]

  [./diff_K]
    type = Diffusion
    variable = K
  [../]

  [./time_H]
    type = TimeDerivative
    variable = H
  [../]

  [./diff_H]
    type = Diffusion
    variable = H
  [../]

  [./time_CO3]
    type = TimeDerivative
    variable = CO3
  [../]

  [./diff_CO3]
    type = Diffusion
    variable = CO3
  [../]

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
# Charge neutrality
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

# -------------------------------------------------
# Boundary conditions (zero flux)
# -------------------------------------------------
[BCs]
  [./noflux]
    type = NeumannBC
    boundary = 'left right'
    variable = K
    value = 0.0
  [../]
[]

# (NeumannBC applies implicitly to all diffusive vars)



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
