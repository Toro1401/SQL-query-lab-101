// Stateless seeded 32-bit mixer. Reproducible, non-cryptographic draws.
function rnd(key){let x=Number(key)>>>0;x^=x>>>16;x=Math.imul(x,0x7feb352d);x^=x>>>15;x=Math.imul(x,0x846ca68b);x^=x>>>16;return x>>>0;}
function bitcount(v){let n=Number(v)>>>0,c=0;while(n){n&=n-1;c++;}return c;}
module.exports={rnd,bitcount};
