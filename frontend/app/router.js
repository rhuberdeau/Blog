import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.resource('articles', function() {
    this.resource('article', { path: '/:article_id' });
  });
  this.route('admin', {}, function() {});
});

export default Router;