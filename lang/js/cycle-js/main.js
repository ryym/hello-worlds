/*
 * http://cycle.js.org/basic-examples.html
 */

import checkboxToggle from './src/checkbox-toggle';
import timer from './src/timer';
import randomUser from './src/random-user';
import counter from './src/counter';
import bmiCalculator from './src/bmi-calculator';
import bmiCalculator2 from './src/bmi-calculator2';

checkboxToggle();
timer();
randomUser();
counter();
bmiCalculator();
bmiCalculator2();


/*
 * Note about Drivers
 *
 * Drivers are side-effectful functions with Observables as input and output.
 * They read from the external world and write side effects.
 * They should focus solely on being an interface for effects.
 * By isolating side effects as Drivers, `main()` function can focus on business
 * logic related to the app's behivour.
 */
