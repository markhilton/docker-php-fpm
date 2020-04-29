<?php

if (isset($_SERVER['TEST_EMAIL']) && trim($_SERVER['TEST_EMAIL']) != "") {
  $email = $_SERVER['TEST_EMAIL'];
  $subject = "PHP email test script";
  $message = "This is a test email to confirm that the PHP mail function works!";
  $headers = "From: " . $email;

  mail($email, $subject, $message, $headers);
}
