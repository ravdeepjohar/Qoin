<?php
	$handle = fopen("./output/result.txt", "r");
	$buffer = fgets($handle, 4096);
    echo $buffer;


?>



