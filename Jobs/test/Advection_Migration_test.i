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

[Variables]
  [c]
    family = LAGRANGE
    order = FIRST
  []

  [phi]
    family = LAGRANGE
    order = FIRST
    initial_condition = 5.0
  []
[]

[ICs]
  [c_ic]
    type = FunctionIC
    variable = c
    function = 'exp(-50*((x-0.5)^2 + (y-0.5)^2))'
  []
[]

# -----------------------
# Kernels
# -----------------------
[Kernels]

  # Time derivative
  [c_dt]
    type = ADTimeDerivative
    variable = c
  []
    [c_laplace]
    type = ADMatDiffusion
    variable = phi
    diffusivity = D1
  []

  # Your custom Nernst–Planck migration kernel
  [migration]
    type = AD_NernstPlanckMigration     
    variable = c
    electric_potential = 5
    charge = z1
    diffusivity = D1
    temperature = 298
  []
  [phi_laplace]
    type = ADDiffusion
    variable = phi
  []
    [conv]
    type = AD_Convection
    variable = c
    velocity = '100 0 0'
  []
[]

[Materials]
  [transport]
    type = ADGenericConstantMaterial
    prop_names  = 'z1 D1'
    prop_values = '1 1'
  []
[]


# -----------------------
# Boundary conditions
# -----------------------
[BCs]

  # Electric potential: linear field
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
    value = 100.0
  []

  # No-flux for concentration (implicit via weak form)
[]

# -----------------------
# Executioner
# -----------------------
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

# -----------------------
# Outputs
# -----------------------
[Outputs]
  exodus = true
  csv = true
[]
