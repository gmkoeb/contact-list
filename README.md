# Contact List

## Content Table
- [Instalation and Execution](#instalation-and-execution)
- [Tests](#tests)
- [API Documentation](#api-documentation)

## Instalation and Execution
To execute the application you must:
1. Clone the repository

2. Inside the api folder: 

        cd contact-list/api

3. Run:

       bundle install 

4. Then:

        bundle exec rails secret 

5. Copy the generated code and run:

        EDITOR='code --wait' rails credentials:edit

6. Inside the opened file, create a variable called:

        devise_jwt_secret_key: CODE GENERATED IN STEP 4

Save and close the file

7. In the end, you should have something like this:

![image](https://github.com/gmkoeb/contact-list/assets/105087841/cc8961d1-a892-42c9-994c-a712861c84a2)

8. Inside the api folder run:

        rails db:create db:migrate db:seed

9. Finally you can start the API server by running

        rails s

10. The api should be up in the URL:

        http://localhost:3000

11. To start the front end, just go to the web folder and run:

        npm install

12. And finally:

        npm run dev

13. The front end should be up in the URL:

        http://localhost:5173

## Tests
To run the tests you must:

1. Complete the steps 1-7 in section 1:

2. Inside the API folder, run:

       rspec

## API Documentation
To see the documentation you have to:

1. After following the steps 1-9 in section 1, go to:

        http://localhost:3000/api-docs
