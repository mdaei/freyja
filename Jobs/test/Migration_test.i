[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 20
  xmin = 0
  xmax = 2
  ymin = 0
  ymax = 1
[]

[Variables]
  [c]
    family = LAGRANGE
    order = FIRST
    initial_condition = 1.0
  []

  [phi]
    family = LAGRANGE
    order = FIRST
    initial_condition = 0.0
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
    diffusivity = 1
  []

  # Your custom Nernst–Planck migration kernel
  [migration]
    type = AD_NernstPlanckMigration     
    variable = c
    electric_potential = phi
    charge = 1.0
    diffusivity = 1
    temperature = 298
  []
  [phi_laplace]
    type = ADDiffusion
    variable = phi
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
    value = 1.0
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
