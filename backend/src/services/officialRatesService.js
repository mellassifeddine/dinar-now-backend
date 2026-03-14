const https = require('https');

const XLS_URL =
'https://www.bank-of-algeria.dz/wp-content/uploads/2024/01/Taux-de-change-du-dinar-algerien.xlsx';

const META = {
EUR:{name:'Euro',flag:'🇪🇺'},
USD:{name:'U.S. Dollar',flag:'🇺🇸'},
GBP:{name:'British Pound',flag:'🇬🇧'},
CAD:{name:'Canadian Dollar',flag:'🇨🇦'},
CHF:{name:'Swiss Franc',flag:'🇨🇭'},
CNY:{name:'Chinese Yuan',flag:'🇨🇳'},
SAR:{name:'Saudi Riyal',flag:'🇸🇦'},
AED:{name:'UAE Dirham',flag:'🇦🇪'},
QAR:{name:'Qatar Riyal',flag:'🇶🇦'},
TND:{name:'Tunisian Dinar',flag:'🇹🇳'},
MAD:{name:'Moroccan Dirham',flag:'🇲🇦'},
EGP:{name:'Egyptian Pound',flag:'🇪🇬'},
};

function fetchText(url){
return new Promise((resolve,reject)=>{
https.get(url,res=>{
let data='';
res.on('data',c=>data+=c);
res.on('end',()=>resolve(data));
}).on('error',reject);
});
}

function buildInverse(rate,symbol){
const inv=1/rate;
return `1 DZD = ${inv.toFixed(4)} ${symbol}`;
}

async function getOfficialRates(){

const html=await fetchText('https://www.bank-of-algeria.dz/');

const rows=[];

for(const symbol of Object.keys(META)){

const r=new RegExp(`${symbol}[^0-9]{0,10}([0-9]+[.,][0-9]+)`,'i');
const m=html.match(r);

if(!m)continue;

const value=parseFloat(m[1].replace(',','.'));

rows.push({
currency:symbol,
name:META[symbol].name,
flag:META[symbol].flag,
buy:0,
sell:value,
inverseText:buildInverse(value,symbol),
updated_at:new Date().toISOString()
});
}

if(!rows.length){
throw new Error('No official rates parsed');
}

return rows;

}

module.exports={getOfficialRates};
