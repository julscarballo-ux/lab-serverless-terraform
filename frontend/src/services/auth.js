export function isAuthenticated(){ 

 

  const token = 

  localStorage.getItem("token"); 

 

  return !!token; 

} 

function logout(){ 

 

  localStorage.clear(); 

 

  window.location.reload(); 

} 