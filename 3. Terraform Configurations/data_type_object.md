# Terraform Object Data Type

Terraform provides several collection data types for storing related values.

Two commonly used types are:

- **Map**
- **Object**

Although both store data as **key-value pairs**, they are designed for different purposes.

---

# Map vs Object

| Feature | Map | Object |
|---------|-----|--------|
| Keys | Always strings | Named attributes |
| Values | All values must be the same type | Each attribute can have its own type |
| Structure | Flexible | Fixed schema |
| Extra Attributes | Allowed | Ignored during type conversion |
| Best Use | Dynamic key-value pairs | Structured data |

---

# Map Data Type

A **Map** is a collection of key-value pairs.

Characteristics:

- Keys are always strings.
- Every value must have the same data type.
- The structure does not need to be predefined.
- Commonly used for AWS tags and configuration values.

Example:

```text
{
  Name = "Sri"
  Age  = "30"
}
```

---

# Map Syntax

```hcl
map(<TYPE>)
```

Examples:

```hcl
map(string)
```

```hcl
map(number)
```

---

# Example 1 – Generic Map

```hcl
variable "my-map" {

  type = map(string)

}

output "variable_value" {

  value = var.my-map

}
```

Run:

```bash
terraform apply -auto-approve
```

Input:

```text
{"Name"="Sri", "Age"="30"}
```

Output:

```text
my-map = tomap({
  "Age"  = "30"
  "Name" = "Sri"
})
```

---

# Another Example

Input:

```text
{"Name"="Sri", "Age"="32", "Location"="UK"}
```

Output:

```text
my-map = tomap({
  "Age"      = "32"
  "Location" = "UK"
  "Name"     = "Sri"
})
```

Maps allow additional keys because the structure is flexible.

---

# Example Test Cases

```text
{"Name"="Sri","Age"="32"}
```

```text
{"Name"="Sri","Age"="32","Location"="UK"}
```

Both are valid.

---

# Example 2 – Map of Numbers

You can restrict the map so that every value must be a number.

```hcl
variable "my-map" {

  type = map(number)

}

output "variable_value" {

  value = var.my-map

}
```

---

## Invalid Input

```text
{"Name"="Sri", "Age"="32"}
```

Terraform returns:

```text
Error: Invalid value for input variable

a number is required.
```

because `"Sri"` is a string.

---

## Valid Input

```text
{
  "Age"      = 32
  "Location" = 45
  "Name"     = 12
}
```

Output:

```text
my-map = tomap({
  "Age"      = 32
  "Location" = 45
  "Name"     = 12
})
```

Every value is a number, so Terraform accepts it.

---

# Object Data Type

An **Object** is a collection of **named attributes**, where **each attribute has its own data type**.

Unlike a map, an object has a **fixed schema**.

---

# Object Syntax

```hcl
object({
  <KEY> = <TYPE>,
  <KEY> = <TYPE>
})
```

Example:

```hcl
object({

  Name   = string

  userID = number

})
```

---

# Object Schema

An object defines:

- Required attribute names
- Data type of each attribute

Example:

```text
Name   → string

userID → number
```

Terraform validates every value against this schema.

---

# Example 3 – Object Data Type

```hcl
variable "my-object" {

  type = object({

    Name   = string

    userID = number

  })

}

output "variable_value" {

  value = var.my-object

}
```

---

# Valid Input

```text
{"Name"="Sri","userID"=1234}
```

Output:

```text
variable_value = {
  "Name"   = "Sri"
  "userID" = 1234
}
```

---

# Invalid Input

```text
{"Name"="Sri","userID"="hello"}
```

Terraform returns:

```text
Error: Invalid value for input variable

a number is required.
```

because:

```text
userID
```

must be a number.

---

# Extra Attributes

One important feature of objects is that **extra attributes are discarded during type conversion**.

Example input:

```text
{"Name"="Sri","userID"=4567,"Location"="India"}
```

Terraform output:

```text
variable_value = {
  "Name"   = "Sri"
  "userID" = 4567
}
```

Notice:

```text
Location
```

is ignored because it is **not part of the object schema**.

---

# Map vs Object Example

## Map

```hcl
type = map(string)
```

Input:

```text
{
  Name = "Sri"
  Age = "30"
  Location = "UK"
}
```

Result:

```text
All keys are accepted.
```

---

## Object

```hcl
type = object({

  Name = string

  userID = number

})
```

Input:

```text
{
  Name = "Sri"
  userID = 4567
  Location = "India"
}
```

Result:

```text
Location is discarded.
```

---

# When to Use a Map

Use a map when:

- Keys are not known in advance.
- Every value has the same type.
- The structure is flexible.
- Storing tags or configuration values.

Examples:

- AWS Tags
- Environment variables
- Region mappings
- Feature flags

---

# When to Use an Object

Use an object when:

- You know exactly which attributes are required.
- Different attributes have different data types.
- You want strict validation.
- You are defining structured input variables.

Examples:

- User information
- Server configuration
- Database settings
- Network configuration

---

# Best Practices

- Use **maps** for flexible key-value collections.
- Use **objects** when the structure should be validated.
- Define explicit types for objects whenever possible.
- Use objects for module input variables to improve validation and readability.

---

# Summary

| Feature | Map | Object |
|---------|-----|--------|
| Keys | Strings | Named attributes |
| Values | Same type | Different types allowed |
| Schema | Flexible | Fixed |
| Extra attributes | Allowed | Ignored during conversion |
| Validation | Type only | Type and structure |

---

# Key Takeaways

- A **Map** stores flexible key-value pairs where all values are the same type.
- An **Object** stores structured data with named attributes, each having its own data type.
- Objects provide stronger validation than maps.
- Extra attributes supplied to an object are discarded if they are not defined in the object's schema.
