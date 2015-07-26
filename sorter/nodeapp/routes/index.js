var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
    // res.render('index', { title: 'Express' });
    req.db.find({}, function(e, docs)
                   {
                       res.send(docs);
                   });
});

router.post('/item', function(req, res, next) {
    // res.render('index', { title: 'Express' });
    req.db.findOne({ id: req.body.id }, function(e, doc)
                   {
                       if(doc)
                           {
                               res.send(doc.action);
                           }
                           else
                               {
                                   res.send("store");
                               }
                   });
});

// router.post('/item', function(req, res, next) {
//   db.findOne({
// });

module.exports = router;
