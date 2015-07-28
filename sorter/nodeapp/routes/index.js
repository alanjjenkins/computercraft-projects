var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/items', function(req, res, next) {
    // res.render('index', { title: 'Express' });
    req.db.find({}, function(e, docs)
                   {
                       res.send(docs);
                   });
});

router.get('/item', function(req, res, next) {
    // res.render('index', { title: 'Express' });
    req.db.findOne({ id: req.query.id }, function(e, doc)
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

router.post('/item', function(req, res, next) {
    var item_action = req.body.action ? req.body.action : 'undefined';
    req.db.insert({ id: req.body.id, action: item_action }, function(e, doc)
{
    if(e) throw e;
    res.send(doc);
});
});

router.post('/item/edit', function(req, res, next) {
    var item_action = req.body.action ? req.body.action : 'undefined';
    req.db.findAndModify({ id: req.body.id }, { id: req.body.id,  action: item_action }, function(e, doc)
{
    if(e) throw e;
    res.send(doc);
});
});

// router.post('/item', function(req, res, next) {
//   db.findOne({
// });

module.exports = router;
