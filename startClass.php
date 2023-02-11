<?php
/**
* Define autoloader.
* @param string $class_name
 */
function __autoload($class_name) {
  include 'class.' . $class_name . '.inc';
}
 
$database = new Database('database');
$db = $database->conn;
 
$q2 = $db->prepare("show columns from <tablename>");
$data = array();
try {$q2->execute($data);}
catch (PDOException $e) {print "q2 failed...  $e     \n";}
$q2->setFetchMode(PDO::FETCH_ASSOC);
$k=0;
print "// Genrated by startClass.php\n";
while ($row2 = $q2->fetch()) {
    //$k++; if($k > 5) continue;
    $x = $row2['Field'];
    print 'protected $'.$x.'=null; function set_'.$x.'($p1) {$this->'.$x.' = $p1;} function get_'.$x.'() {return $this->'.$x.';}';
    print "\n";
}
 
exit(1);
