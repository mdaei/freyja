[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 400
  xmin = 0
  xmax = 2e-7
[]

[Variables]
  [./c_plus]
    initial_condition = 1000
  [../]

  [./c_minus]
    initial_condition = 1000
  [../]

  [./phi]
    initial_condition = 0
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

# ---------- Current ramp ----------
[Functions]
  [./current_ramp]
    type = PiecewiseLinear
    x = '0 1e-7'
    y = '0 1e4'
  [../]
[]

[BCs]
  # ---------- Electrode (x = 0) ----------
  [./c_plus_current]
    type = ADCurrentFluxBC
    variable = c_plus
    boundary = left
    j_tot = current_ramp
    gamma = 1.0
  [../]

  [./c_minus_current]
    type = ADCurrentFluxBC
    variable = c_minus
    boundary = left
    j_tot = current_ramp
    gamma = -1.0
  [../]

  # ---------- Bulk reservoir (x = L) ----------
  [./c_plus_bulk]
    type = DirichletBC
    variable = c_plus
    boundary = right
    value = 1000
  [../]

  [./c_minus_bulk]
    type = DirichletBC
    variable = c_minus
    boundary = right
    value = 1000
  [../]

  [./phi_bulk]
    type = DirichletBC
    variable = phi
    boundary = right
    value = 0
  [../]
[]

[Executioner]
  type = Transient
  scheme = implicit-euler

  dt = 1e-12
  dtmin = 1e-14
  end_time = 1e-7

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-11
  nl_max_its = 40

  l_max_its = 200

  petsc_options_iname = '-snes_linesearch_type'
  petsc_options_value = 'bt'
[]


// [Executioner]
//   type = Transient
//   scheme = implicit-euler

//   dt = 1e-12
//   dtmin = 1e-14
//   dtmax = 1e-9
//   end_time = 1e-7

//   nl_rel_tol = 1e-8
//   nl_abs_tol = 1e-11
//   nl_max_its = 40

//   l_max_its = 200

//   petsc_options_iname = '-snes_linesearch_type'
//   petsc_options_value = 'bt'

//   [./TimeStepper]
//     type = IterationAdaptiveDT
//     optimal_iterations = 10
//     growth_factor = 1.3
//     cutback_factor = 0.5
//   [../]
// []


[Outputs]
  exodus = true
  csv = true
[]
