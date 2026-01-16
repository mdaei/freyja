#include "IonicMobilityMaterial.h"

registerMooseObject("freyjaApp", IonicMobilityMaterial);

InputParameters
IonicMobilityMaterial::validParams()
{
  InputParameters params = ADMaterial::validParams();

  params.addRequiredParam<Real>("D", "Diffusion coefficient [m^2/s]");
  params.addRequiredParam<Real>("z", "Charge number");
  params.addParam<Real>("F", 96485.3329, "Faraday constant [C/mol]");
  params.addParam<Real>("R", 8.314462618, "Gas constant [J/mol/K]");
  params.addRequiredParam<Real>("T", "Temperature [K]");

  params.addParam<MaterialPropertyName>(
      "property_name", "mobility",
      "Name of the mobility material property");

  return params;
}

IonicMobilityMaterial::IonicMobilityMaterial(const InputParameters & parameters)
  : ADMaterial(parameters),
    _mobility(declareADProperty<Real>(getParam<MaterialPropertyName>("property_name"))),
    _D(getParam<Real>("D")),
    _z(getParam<Real>("z")),
    _F(getParam<Real>("F")),
    _R(getParam<Real>("R")),
    _T(getParam<Real>("T"))
{
}

void
IonicMobilityMaterial::computeQpProperties()
{
  _mobility[_qp] = _D * _z * _F / (_R * _T);
}
