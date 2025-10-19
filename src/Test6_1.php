<?php

/**
 * 等価演算子の解釈がPHP7からPHP8で変わった！
 */

echo "PHP Ver." . phpversion() . "\n\n";

var_dump(0=='');
var_dump(0=='hello');
var_dump(5=='5px');

echo "\nend.\n";
