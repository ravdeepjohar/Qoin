<?php
#-------------------------------------------------------------------------------
# EE368 Digital Image Processing
# Android Tutorial #3: Server-Client Interaction Example for Image Processing
# Author: Derek Pang (dcypang@stanford.edu), David Chen (dmchen@stanford.edu)
#------------------------------------------------------------------------------

#function for streaming file to client
function streamFile($location, $filename, $mimeType='application/octet-stream')
{ if(!file_exists($location))
  { header ("HTTP/1.0 404 Not Found");
    return;
  }
  
  $size=filesize($location);
  $time=date('r',filemtime($location));
  #html response header
  header('Content-Description: File Transfer');	
  header("Content-Type: $mimeType"); 
  header('Cache-Control: public, must-revalidate, max-age=0');
  header('Pragma: no-cache');  
  header('Accept-Ranges: bytes');
  header('Content-Length:'.($size));
  header("Content-Disposition: inline; filename=$filename");
  header("Content-Transfer-Encoding: binary\n");
  header("Last-Modified: $time");
  header('Connection: close');      

  ob_clean();
  flush();
  readfile($location);
	
}

#**********************************************************
#Main script
#**********************************************************

#<1>set target path for storing photo uploads on the server
$photo_upload_path = "./upload/";
$photo_upload_path = $photo_upload_path. basename( $_FILES['uploadedfile']['name']); 
#<2>set target path for storing result on the server
//$downloadFileName = 'processed_';
$processed_photo_output_path = "./output/result1.txt";
//$processed_photo_output_path = $processed_photo_output_path. basename( $_FILES['uploadedfile']['name']); 
//$downloadFileName = $outname . basename( $_FILES['uploadedfile']['name']); 

#<3>modify maximum allowable file size to 10MB and timeout to 300s
ini_set('upload_max_filesize', '10M');  
ini_set('post_max_size', '10M');  
ini_set('max_input_time', 30000);  
ini_set('max_execution_time', 30000);  

#<4>Get and stored uploaded photos on the server
if(copy($_FILES['uploadedfile']['tmp_name'], $photo_upload_path)) {
	
	#<5> execute matlab image processing algorithm
	#example: Compute and display SIFT features using VLFeat and Matlab
	$command = "matlab -nojvm -nodesktop -nodisplay -r \"randc;exit\"";
	exec($command);
	
		while(!file_exists($processed_photo_output_path)){
		usleep(500000);
	}
	usleep(100000);
	#<6>stream processed photo to the client
	$handle = fopen("./output/result1.txt", "r");
	$buffer = fgets($handle, 4096);
	fclose($handle);
	$command = "matlab -nojvm -nodesktop -nodisplay -r \"dele;exit\"";
	exec($command);
    echo $buffer;
	} else{
    echo "There was an error uploading the file to $photo_upload_path !";
}

?>



