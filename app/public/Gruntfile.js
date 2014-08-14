module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('bower.json'),
    html2js: {
      options: {
        module: 'community-templates',
        useStrict: true,
      },
      main: {
        src: ['js/**/*.tpl.html'],
       dest: 'js/templates.js'
      },
    },
  });

  grunt.loadNpmTasks('grunt-html2js');


  grunt.registerTask('default', ['html2js']);

};
