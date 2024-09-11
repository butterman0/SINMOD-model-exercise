import numpy as np

def dens(S, T):
    """
    Calculate water density from salinity and temperature.

    Parameters:
    S (2D array): Salinity
    T (2D array): Temperature

    Returns:
    rho (2D array): Density
    """
    # Define constants for the equation
    a0 = 999.842594
    a1 = 6.793952e-02
    a2 = -9.095290e-03
    a3 = 1.001685e-04
    a4 = -1.120083e-06
    a5 = 6.536332e-09
    b0 = 8.24493e-01
    b1 = -4.0899e-03
    b2 = 7.6438e-05
    b3 = -8.2467e-07
    b4 = 5.3875e-09
    c0 = -5.72466e-03
    c1 = 1.0227e-04
    c2 = -1.6546e-06
    d0 = 4.8314e-04

    # Convert temperature to Kelvin
    T = T + 273.15

    # Calculate density
    rho = (a0 + (a1*T) + (a2*T**2) + (a3*T**3) + (a4*T**4) + (a5*T**5) +
           (b0*S) + (b1*S*T) + (b2*S*T**2) + (b3*S*T**3) + (b4*S*T**4) +
           (c0*S**(1.5)) + (c1*S**(1.5)*T) + (c2*S**(1.5)*T**2) +
           (d0*S**2))

    return rho
