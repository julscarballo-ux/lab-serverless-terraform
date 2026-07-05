exports.handler = async (event) => { 

   const claims = 

   event.requestContext.authorizer.claims; 

   const ownerId = claims.sub; 

   const email = claims.email; 

   return { 

       statusCode: 200, 

       body: JSON.stringify({ 

           message: "Archivo creado", 

           ownerId, 

           email 

       }) 

   }; 

}; 
