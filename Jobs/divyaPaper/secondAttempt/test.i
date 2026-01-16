[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 50
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

[Functions]
  [./phi_ext]
    type = ParsedFunction
    # Linear potential → constant E-field
    expression = '-E*x'
    symbol_names = 'E'
    symbol_values = '10.0'
  [../]
[]

[Materials]
  [./mobility]
    type = IonicMobilityMaterial
    D = 1.0
    z = 1.0
    T = 1.0
    property_name = mobility
  [../]
[]

[Kernels]
  [./time]
    type = TimeDerivative
    variable = c
  [../]

  [./diff]
    type = Diffusion
    variable = c
    diffusivity = 1.0
  [../]

  [./mig]
    type = ADMigration
    variable = c
    c = c
    mobility = mobility
    electric_potential = phi_ext
  [../]
[]

[BCs]
  # Zero flux at both ends
[]

[Executioner]
  type = Transient
  scheme = bdf2
  dt = 0.01
  end_time = 0.2
  solve_type = NEWTON
[]

[Outputs]
  exodus = true
[]
