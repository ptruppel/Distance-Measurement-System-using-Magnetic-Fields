# Distance Measurement System using Magnetic Fields

The measurement system that has been investigated uses knowledge of how magnetic fields permeate through space. This project was done in order to create a sensing tool to determine the distance between two moving carts that follow each other along a track. When the distance between the carts decreases and a crash is evident, a hall effect sensor picks up the change in magnetic field and will apply a breaking mechanism to one cart. The leading cart is equipped with a magnet facing the following cart and the following cart will be equipped with a hall effect sensor facing the first cart. The output voltage of the Hall effect sensor is then used to determine the distance between the carts. The following cart is configured with a DC motor where if the carts get too close to each other, the cart that is following will slow down.

## Getting Started

Open up MATLAB and simply run the simulation and the validation Arduino code in order to run the experiment yourself.

### Prerequisites

MATLAB license and Arduino download. 

## Deployment

The MATLAB code is just for analysis. The Arduino code can be uploaded to an Arduino UNO that is used as the microcontroller for this project. 

## Built With

* [MATLAB](https://www.mathworks.com/products/matlab.html) - The coding environment used
* [Arduino](https://www.arduino.cc/) - The other coding environment used

## Contributing

Please read [CONTRIBUTING.md]() for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Phillip Truppelli** - *Initial work* -
* **Kausthubh Gadamsetty** - *Initial work* - 
* **Josh Hayward** - *Initial work* -

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is not licensed - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

This project was helped along by:

https://github.com/canozcivelek/auto-braking-rc-car/blob/master/autoBrake/autoBrake.ino#L11

https://roboindia.com/tutorials/digital-analog-hall-magnetic-sensor-arduino/

