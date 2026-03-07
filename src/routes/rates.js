const express = require('express');
const db = require('../db/database');

const router = express.Router();

router.get('/parallel',(req,res)=>{

  db.all(
    `SELECT currency,buy,sell FROM rates ORDER BY currency ASC`,
    [],
    (err,rows)=>{
      if(err){
        return res.status(500).json({error:err.message});
      }
      res.json(rows);
    }
  );

});

router.post('/update',(req,res)=>{

  const {currency,buy,sell}=req.body;

  if(!currency){
    return res.status(400).json({error:'currency required'});
  }

  db.run(
    `UPDATE rates SET buy=?,sell=? WHERE currency=?`,
    [buy,sell,currency],
    function(err){

      if(err){
        return res.status(500).json({error:err.message});
      }

      res.json({
        success:true,
        currency
      });

    }
  );

});

module.exports = router;
