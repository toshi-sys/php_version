<?php

/**
 * 等価演算子の解釈がPHP7からPHP8で変わった！
 * 
 * プログラム実行　↓
 * ・「Ctrl+Shift+P」
 * ・「Tasks: Run Task」選択
 * ・実行するバージョンのタスク（Run With PHP X.X）を選択
 */

echo "PHP Ver." . phpversion() . "\n\n";

var_dump(0=='');
var_dump(0=='hello');
var_dump(5=='5px');

echo "\nend.\n";
