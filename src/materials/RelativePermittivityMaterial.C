#include "RelativePermittivityMaterial.h"

registerMooseObject("freyjaApp", RelativePermittivityMaterial);

InputParameters
RelativePermittivityMaterial::validParams()
{
  InputParameters params = ADMaterial::validParams();

  params.addRequiredCoupledVar("concentrations",
                               "All ionic concentrations");

  params.addRequiredParam<std::vector<Real>>(
      "w", "Partial molar volumes or weights");

  params.addParam<Real>("epsilon_0", 8.8541878128e-12,
                         "Vacuum permittivity");

  params.addRequiredParam<Real>("epsilon_water",
                                "Relative permittivity of water");

  params.addRequiredParam<Real>("epsilon_min",
                                "Minimum relative permittivity");

  params.addRequiredParam<Real>("M_water",
                                "Molar concentration of water");

  return params;
}

RelativePermittivityMaterial::RelativePermittivityMaterial(
    const InputParameters & parameters)
  : ADMaterial(parameters),
    _epsilon(declareADProperty<Real>("epsilon")),
    _w(getParam<std::vector<Real>>("w")),
    _eps0(getParam<Real>("epsilon_0")),
    _eps_water(getParam<Real>("epsilon_water")),
    _eps_min(getParam<Real>("epsilon_min")),
    _M_water(getParam<Real>("M_water"))
{
  const unsigned int n_vars = coupledComponents("concentrations");

  if (n_vars != _w.size())
    mooseError("Number of concentrations must match number of weights");

  _c_vars.reserve(n_vars);

  for (unsigned int i = 0; i < n_vars; ++i)
    _c_vars.push_back(&adCoupledValue("concentrations", i));
}

void
RelativePermittivityMaterial::computeQpProperties()
{
  ADReal water_fraction = 0.0;

  for (unsigned int i = 0; i < _c_vars.size(); ++i)
    water_fraction += _w[i] * (*_c_vars[i])[_qp];

  water_fraction /= _M_water;

  const ADReal eps_r =
      _eps_water * (1.0 - water_fraction) +
      _eps_min * water_fraction;

  _epsilon[_qp] = _eps0 * eps_r;
}
