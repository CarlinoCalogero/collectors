<!DOCTYPE html>
<html>
<head>
  <title>Stampa "Scemo chi legge"</title>
</head>
<body>
  <?php
  if (isset($_POST['submit'])) {
    echo "Scemo chi legge";
  }
  ?>
  
  <form method="POST" action="">
    <input type="submit" name="submit" value="Premi per stampare">
  </form>
</body>
</html>
