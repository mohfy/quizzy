# quizzy
create quizzes and play them!

## FAQ
how to create quizzes?
- you can create a json file then use the following template:
  
  ```
  {
  "title": "Example title",
  "content": [
    {
      "question": "Example title for the question?",
      "option1": "heres option 1",
      "option2": "heres option 2",
      "option3": "heres option 3",
      "option4": "heres option 4",
      "answer": 1    # the number will show which option is right, ex. if option 1 is correct number should be one
    },
    # add more questions here
    ]
  }

- then save the file with filetype "quizzy"
