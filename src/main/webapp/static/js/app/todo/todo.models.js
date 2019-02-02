//Models
TodoApp.Models.FeedbackMessage = Backbone.Model.extend();

TodoApp.Models.Todo = Backbone.Model.extend({
    urlRoot: "/spring-test-mvc-configuration/api/todo"
});

//Collections
TodoApp.Collections.Todos = Backbone.Collection.extend({
    model: TodoApp.Models.Todo,
    url: function() {
        return "/spring-test-mvc-configuration/api/todo";
    }
})