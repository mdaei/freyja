#include "freyjaApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
freyjaApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

freyjaApp::freyjaApp(const InputParameters & parameters) : MooseApp(parameters)
{
  freyjaApp::registerAll(_factory, _action_factory, _syntax);
}

freyjaApp::~freyjaApp() {}

void
freyjaApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<freyjaApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"freyjaApp"});
  Registry::registerActionsTo(af, {"freyjaApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
freyjaApp::registerApps()
{
  registerApp(freyjaApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
freyjaApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  freyjaApp::registerAll(f, af, s);
}
extern "C" void
freyjaApp__registerApps()
{
  freyjaApp::registerApps();
}
