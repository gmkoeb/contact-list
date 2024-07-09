import React from 'react'
import { Field, ErrorMessage, useFormikContext } from 'formik';

const TextInput = ({ name, type, placeholder, label }) => {
  const { touched, errors } = useFormikContext()

  const fieldError = touched[name] && errors[name]
  const fieldClassName = fieldError
    ? "px-2 text-black py-2 font-semibold rounded-lg border-2 border-red-600 focus:outline-red-600 w-72"
    : "px-2 text-black py-2 font-semibold rounded-lg border-2 border-gray-500 w-72"

  return (
    <div className='flex flex-col text-left'>
      <label htmlFor={name}>{label}</label>
      <Field
        className={fieldClassName}
        type={type}
        name={name}
        placeholder={placeholder}
        id={name}
      />
      <ErrorMessage className='text-red-600' name={name} component="div" />
    </div>
  );
};

export default TextInput;