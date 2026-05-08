<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reset Password — TrustNet</title>
<link rel="stylesheet" href="/styles/main.css">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
<nav><div class="nav-inner"><a class="logo" href="/"><div class="logo-mark">T</div>TrustNet</a></div></nav>
<div class="auth-page">
  <div class="auth-card">
    <div class="auth-icon">&#128274;</div>
    <h2>Set new password</h2>
    <p class="auth-sub">Choose a new password for your account</p>
    <div id="resetError" class="error-box" style="display:none"></div>
    <div class="form-field"><label>New password</label><input class="form-input" type="password" id="newPass" placeholder="Min 8 characters"></div>
    <div class="form-field"><label>Confirm new password</label><input class="form-input" type="password" id="confirmPass" placeholder="Repeat password"></div>
    <button class="btn-full" onclick="doReset()" id="resetBtn">Update password</button>
  </div>
</div>
<script type="module">
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
const SUPABASE_URL = 'https://oymmmevtzbzoneujtkhn.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95bW1tZXZ0emJ6b25ldWp0a2huIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgwMTE4MTQsImV4cCI6MjA5MzU4NzgxNH0.sRrw5cthKfF7k0vP0_ONCLiQN6J4CIerzzu5NRUCXlU';
const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
window.doReset = async () => {
  const newPass = document.getElementById('newPass').value;
  const confirmPass = document.getElementById('confirmPass').value;
  if (newPass.length<8) { showErr('Password must be at least 8 characters.'); return; }
  if (newPass!==confirmPass) { showErr('Passwords do not match.'); return; }
  const btn = document.getElementById('resetBtn');
  btn.textContent='Updating...'; btn.disabled=true;
  const { error } = await supabase.auth.updateUser({ password: newPass });
  if (error) { showErr(error.message); btn.textContent='Update password'; btn.disabled=false; return; }
  location.href='/login.html';
};
function showErr(msg) { const e=document.getElementById('resetError'); e.textContent=msg; e.style.display='block'; }
</script>
</body>
</html>
