//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "freyjaTestApp.h"
#include "freyjaApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
freyjaTestApp::validParams()
{
  InputParameters params = freyjaApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

freyjaTestApp::freyjaTestApp(const InputParameters & parameters) : MooseApp(parameters)
{
  freyjaTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

freyjaTestApp::~freyjaTestApp() {}

void
freyjaTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  freyjaApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"freyjaTestApp"});
    Registry::registerActionsTo(af, {"freyjaTestApp"});
  }
}

void
freyjaTestApp::registerApps()
{
  registerApp(freyjaApp);
  registerApp(freyjaTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
freyjaTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  freyjaTestApp::registerAll(f, af, s);
}
extern "C" void
freyjaTestApp__registerApps()
{
  freyjaTestApp::registerApps();
}
