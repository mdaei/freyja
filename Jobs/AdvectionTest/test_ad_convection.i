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
  []
[]

# ----------------------------
# Initial condition
# ----------------------------

[ICs]
  [c_ic]
    type = FunctionIC
    variable = c
    function = 'exp(-50*((x-0.5)^2 + (y-0.5)^2))'
  []
[]


# ----------------------------
# Materials (diffusion)
# ----------------------------

[Materials]
  [diffusivity]
    type = ADGenericConstantMaterial
    prop_names = 'diffusivity'
    prop_values = '1e-3'
  []
[]

# ----------------------------
# Kernels
# ----------------------------

[Kernels]
    
  [time]
    type = ADTimeDerivative
    variable = c
  []

  [diff]
    type = ADMatDiffusion
    variable = c
    diffusivity = 1
  []

  [conv]
    type = ADConvection
    variable = c
    velocity = '0 5 0'
  []

[]

# ----------------------------
# Boundary conditions
# ----------------------------

# Natural (zero diffusive flux) BCs are fine for this test

# ----------------------------
# Executioner
# ----------------------------

[Executioner]
  type = Transient
  scheme = implicit-euler
  solve_type = NEWTON
  line_search = basic

  dt = 0.01
  end_time = 0.5

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-10
  nl_max_its = 20

  l_tol = 1e-8
  l_max_its = 200
[]

# ----------------------------
# Outputs
# ----------------------------

[Outputs]
  exodus = true
[]

