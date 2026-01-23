
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 60
  ny = 20
  xmin = 0
  xmax = 6
  ymin = 0
  ymax = 1
  boundary_id   = '0 1 2 3'
  boundary_name = 'left right bottom top'
[]

#-----------------------------
# VARIABLES
#-----------------------------
[Variables]
  [c1]
    initial_condition = 1.0
    scaling = 1e-9
  []
  [c2]
    initial_condition = 1.0
    scaling = 1e-9
  []
  [phi]
    initial_condition = 0.0
    scaling = 1.0
  []
[]

#-----------------------------
# MATERIALS
#-----------------------------
[Materials]
  [diffusivities]
    type = ADGenericConstantMaterial
    prop_names = 'D_c1 D_c2 epsr'
    prop_values = '1e-9 1e-9 80.0'
  []
[]

#-----------------------------
# KERNELS: SPECIES c1
#-----------------------------
[Kernels]
  [c1_time]
    type = ADTimeDerivative
    variable = c1
  []

  [c1_diffusion]
    type = ADMatDiffusion
    variable = c1
    diffusivity = D_c1
  []

  [c1_migration]
    type = AD_NernstPlanckMigration
    variable = c1
    electric_potential = phi
    charge = 1
    diffusivity = D_c1
    temperature = 298
  []

  [c1_steric]
    type = AD_Steric
    variable = c1
    diffusivity = D_c1
    concentrations = 'c1 c2'
    molecular_sizes = '3e-10 3e-10'
  []

  [c1_reaction]
    type = AD_Reaction
    variable = c1
    reaction_rate = 10.0
  []

#-----------------------------
# KERNELS: SPECIES c2
#-----------------------------
  [c2_time]
    type = ADTimeDerivative
    variable = c2
  []

  [c2_diffusion]
    type = ADMatDiffusion
    variable = c2
    diffusivity = D_c2
  []
  
  [c2_migration]
    type = AD_NernstPlanckMigration
    variable = c2
    diffusivity = D_c2
    electric_potential = phi
    charge = -1
    temperature = 298
  []

  [c2_steric]
    type = AD_Steric
    variable = c2
    diffusivity = D_c2
    concentrations = 'c1 c2'
    molecular_sizes = '3e-10 3e-10'
  []

  [c2_reaction]
    type = AD_Reaction
    variable = c2
    reaction_rate = 5.0
  []

#-----------------------------
# KERNELS: ELECTROSTATICS
#-----------------------------
  [phi_poisson]
    type = AD_Poisson
    variable = phi
    epsr = epsr
  []

  [phi_charge]
    type = AD_ChargeDensity
    variable = phi
    concentrations = 'c1 c2'
    valences = '1 -1'
  []
[]

#-----------------------------
# BOUNDARY CONDITIONS
#-----------------------------
[BCs]
  [phi_left]
    type = DirichletBC
    variable = phi
    boundary = left
    value = 0.0
  []

  [phi_right]
    type = DirichletBC
    variable = phi
    boundary = right
    value = 0.01
  []

  [c1_left]
    type = NeumannBC
    variable = c1
    boundary = left
    value = 0.0
  []

  [c2_left]
    type = NeumannBC
    variable = c2
    boundary = left
    value = 0.0
  []
[]

#-----------------------------
# EXECUTIONER
#-----------------------------
[Executioner]
  type = Transient
  scheme = bdf2

  dt = 1e-4
  end_time = 5e-2

  solve_type = NEWTON
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-12
  nl_max_its = 20
[]

#-----------------------------
# OUTPUTS
#-----------------------------
[Outputs]
  exodus = true
  console = true
[]
