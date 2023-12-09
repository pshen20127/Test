[Mesh]
  file = resolution16.0.inp
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]

  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[UserObjects]
  [./prop_read]
    type = PropertyReadFile
    prop_file_name = 'euler_ang_test.inp'
    # Enter file data as prop#1, prop#2, .., prop#nprop
    nprop = 3
	nblock = 64
    read_type = block
  [../]
[]


[GlobalParams]
  volumetric_locking_correction = true
[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./fp_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./e_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./elastic_strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./tot_strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./rotout]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vonmises]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [euler_angle_1]
    order = CONSTANT
    family = MONOMIAL
  []
  [euler_angle_2]
     order = CONSTANT
    family = MONOMIAL
  []
  [euler_angle_3]
    order = CONSTANT
    family = MONOMIAL
  []

  [./resid_x]  #-----------This is for the reaction force along the x direction
  [../]

  [./resid_y]  #-----------This is for the reaction force along the y direction
  [../]

[]

[Functions]
  [./tdisp]
    type = ParsedFunction
    value = 0.01*t
  [../]
[]



[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    variable = stress_xx
    rank_two_tensor = stress
    index_j = 0
    index_i = 0
    execute_on = timestep_end
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
    execute_on = timestep_end
  [../]
  [./fp_xx]
    type = RankTwoAux
    variable = fp_xx
    rank_two_tensor = plastic_deformation_gradient
    index_j = 0
    index_i = 0
    execute_on = timestep_end
  [../]
  [./e_xx]
    type = RankTwoAux
    variable = e_xx
    rank_two_tensor = total_lagrangian_strain
    index_j = 0
    index_i = 0
    execute_on = timestep_end
  [../]
  [./elastic_strain_xx]
    type = RankTwoAux
    rank_two_tensor = elastic_strain
    variable = elastic_strain_xx
    index_i = 0
    index_j = 0
    execute_on = timestep_end
  [../]
  [./tot_strain_xx]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = tot_strain_xx
    index_i = 0
    index_j = 0
    execute_on = timestep_end
  [../]
  [./vonmises]
    type = RankTwoScalarAux
    rank_two_tensor = stress
    variable = vonmises
    scalar_type = VonMisesStress
    execute_on = timestep_end
  [../]
  [euler_angle_1]
    type = MaterialRealVectorValueAux
    variable = euler_angle_1
    property = updated_Euler_angle
    component = 0
    execute_on = timestep_end
  []
  [euler_angle_2]
    type = MaterialRealVectorValueAux
    variable = euler_angle_2
    property = updated_Euler_angle
    component = 1
    execute_on = timestep_end
  []
  [euler_angle_3]
    type = MaterialRealVectorValueAux
    variable = euler_angle_3
    property = updated_Euler_angle
    component = 2
    execute_on = timestep_end
  []
[]

[BCs]
  [fix_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'FIXEDX'
    value = 0
  []
  [fix_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'FIXEDY'
    value = 0
  []
  [tdisp]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 'DISPX'
    function = '204*t'
  []
[]

[Modules/TensorMechanics/Master/all]
  strain = FINITE
  add_variables = true
    save_in = 'resid_x resid_y'
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensorCP
    C_ijkl = '243.3e3 156.7e3 156.7e3 243.3e3 156.7e3 243.3e3 117.8e3 117.8e3 117.8e3'
    fill_method = symmetric9
    read_prop_user_object = prop_read
  [../]
[./stress]
  type = ComputeMultipleCrystalPlasticityStress
  crystal_plasticity_models = 'trial_xtalpl'
  tan_mod_type = exact
[../]
[./trial_xtalpl]
  type = CrystalPlasticityKalidindiUpdate
  number_slip_systems = 12
  slip_sys_file_name = input_slip_sys.txt

    r=1.0  #-- latent hardening coefficient
    h=916.5 #-- h0 in the hardening rule
    t_sat=109.8 #-- g_sat
    gss_a=1.0  #-- exponential in the hardening rule
    ao=1.15e-6  #-- this is \dot{gammo}_0  
    xm=0.1 #-- m, the exponential in the power law flow rule
    gss_initial=60.8 # Initial slip resistance
[../]

  [updated_euler_angle]
    type = ComputeUpdatedEulerAngle
    radian_to_degree = true
  []

[]
[Postprocessors]
  [./stress_xx]
    type = ElementAverageValue
    variable = stress_xx
  [../]
  [./stress_yy]
    type = ElementAverageValue
    variable = stress_yy
  [../]
  [./fp_xx]
    type = ElementAverageValue
    variable = fp_xx
  [../]
  [./e_xx]
    type = ElementAverageValue
    variable = e_xx
  [../]
  [./el_strain_xx]
    type = ElementAverageValue
    variable = elastic_strain_xx
  [../]
  [./tot_strain_xx]
    type = ElementAverageValue
    variable = tot_strain_xx
  [../]
  [./vonmises]
    type = ElementAverageValue
    variable = vonmises
  [../]
  [euler_angle_1]
    type = ElementAverageValue
    variable = euler_angle_1
  []
  [euler_angle_2]
    type = ElementAverageValue
    variable = euler_angle_2
  []
  [euler_angle_3]
    type = ElementAverageValue
    variable = euler_angle_3
  []

[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6

  dt = 0.01
  dtmax = 0.1
  end_time = 1.0
  dtmin = 0.00000001

  num_steps = 1000000
[]

[Outputs]
  checkpoint = true
  file_base = resolution16.0
  exodus = true
  csv=true
[]


