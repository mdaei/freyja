[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 100
  xmin = 0
  xmax = 1e-6
[]

[Variables]
  [./c_plus]
    initial_condition = 1000
  [../]

  [./c_minus]
    initial_condition = 1000
  [../]

  [./phi]
  [../]
[]

[Kernels]
  [./c_plus_np]
    type = ADGMPNPKernel
    variable = c_plus
    phi = phi
    concentrations = 'c_plus c_minus'
    D = 1e-9
    z = 1
    ai3 = 1e-28
  [../]

  [./c_minus_np]
    type = ADGMPNPKernel
    variable = c_minus
    phi = phi
    concentrations = 'c_plus c_minus'
    D = 1e-9
    z = -1
    ai3 = 1e-28
  [../]

  [./phi_diff]
    type = ADMatDiffusion
    variable = phi
    diffusivity = epsilon
  [../]

  [./phi_charge]
    type = ADPoissonChargeKernel
    variable = phi
    concentrations = 'c_plus c_minus'
    z = '1 -1'
  [../]
[]

[Materials]
  [./permittivity]
    type = RelativePermittivityMaterial
    concentrations = 'c_plus c_minus'
    w = '1e-5 1e-5'
    epsilon_water = 78.5
    epsilon_min = 6.0
    M_water = 55500
  [../]
[]

[BCs]
  [./phi_left]
    type = DirichletBC
    variable = phi
    boundary = left
    value = 0
  [../]

  [./phi_right]
    type = DirichletBC
    variable = phi
    boundary = right
    value = 0
  [../]
[]

[Executioner]
  type = Transient
  dt = 1e-6
  end_time = 1e-3
  solve_type = NEWTON
[]

[Outputs]
  exodus = true
[]
