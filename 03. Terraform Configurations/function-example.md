# Terraform Functions Example

## Documentation

Terraform Function Reference:

- https://developer.hashicorp.com/terraform/language/functions

Related Function Documentation:

- Lookup Function  
  https://developer.hashicorp.com/nomad/docs/reference/hcl2/functions/collection/lookup

- Length Function  
  https://developer.hashicorp.com/packer/docs/templates/hcl_templates/functions/collection/length

- Element Function  
  https://developer.hashicorp.com/packer/docs/templates/hcl_templates/functions/collection/element

- Format Date Function  
  https://developer.hashicorp.com/packer/docs/templates/hcl_templates/functions/datetime/formatdate


---

# Base Challenge Code

```hcl
provider "aws" {
  region = var.region
}


variable "region" {
  default = "us-east-1"
}


variable "tags" {
  type = list

  default = [
    "firstec2",
    "secondec2"
  ]
}


variable "ami" {
  type = map

  default = {
    "us-east-1" = "ami-08a0d1e16fc3f61ea"
    "us-west-2" = "ami-0b20a6f09484773af"
    "ap-south-1" = "ami-0e1d06225679bc1c5"
  }
}


resource "aws_instance" "app-dev" {

   ami = lookup(var.ami,var.region)

   instance_type = "t2.micro"

   count = length(var.tags)


   tags = {

     Name = element(var.tags,count.index)

     CreationDate = formatdate(
       "DD MMM YYYY hh:mm ZZZ",
       timestamp()
     )
   }
}
```

---

# Terraform Function Examples

Terraform provides many built-in functions that can be used to transform and calculate values inside configuration files.

In this example we are using:

- `lookup()`
- `length()`
- `element()`
- `timestamp()`
- `formatdate()`

---

# 1. lookup Function

## Syntax

```hcl
lookup(map, key, default)
```

The `lookup()` function retrieves a value from a map using a key.

If the key does not exist, it returns the default value.

---

## Example

```hcl
lookup({a="ay", b="bee"}, "a", "what?")
```

Output:

```
ay
```

---

Example when key does not exist:

```hcl
lookup({a="ay", b="bee"}, "c", "wrong")
```

Output:

```
wrong
```

---

## Decoding Terraform Code

Code:

```hcl
ami = lookup(var.ami,var.region)
```

Variable:

```hcl
variable "ami" {

default = {
    "us-east-1" = "ami-08a0d1e16fc3f61ea"
    "us-west-2" = "ami-0b20a6f09484773af"
    "ap-south-1" = "ami-0e1d06225679bc1c5"
  }
}
```

Terraform executes:

```hcl
lookup(
 {
  "us-east-1" = "ami-08a0d1e16fc3f61ea",
  "us-west-2" = "ami-0b20a6f09484773af",
  "ap-south-1" = "ami-0e1d06225679bc1c5"
 },
 "us-east-1"
)
```

Output:

```
ami-08a0d1e16fc3f61ea
```

The AMI ID is selected automatically based on the AWS region.

---

# 2. length Function

## Syntax

```hcl
length(value)
```

The `length()` function returns the number of items in a collection or characters in a string.

---

## Example

```hcl
length("hello")
```

Output:

```
5
```

---

## Decoding Terraform Code

Code:

```hcl
count = length(var.tags)
```

Variable:

```hcl
variable "tags" {

default = [
 "firstec2",
 "secondec2"
]

}
```

Terraform evaluates:

```hcl
length(
 [
  "firstec2",
  "secondec2"
 ]
)
```

Output:

```
2
```

Therefore:

```hcl
count = 2
```

Terraform creates two EC2 instances.

---

# 3. element Function

## Syntax

```hcl
element(list, index)
```

The `element()` function retrieves a single element from a list.

Important:

- Index starts from **0**
- The function returns an error if the list is empty
- If the index is greater than the list length, Terraform wraps around using modulo operation

---

## Example 1

```hcl
element(["a", "b", "c"], 1)
```

Output:

```
b
```

Explanation:

```
Index:
0 = a
1 = b
2 = c
```

---

## Example 2 (Index Wrap Around)

```hcl
element(["a", "b", "c"], 3)
```

Output:

```
a
```

Explanation:

```
Index 3 is greater than list length.

Terraform calculates:

3 % 3 = 0

Therefore it returns index 0.
```

---

## Decoding Terraform Code

Code:

```hcl
Name = element(var.tags,count.index)
```

Variable:

```hcl
tags = [
 "firstec2",
 "secondec2"
]
```

For first instance:

```
count.index = 0
```

Result:

```
Name = firstec2
```

For second instance:

```
count.index = 1
```

Result:

```
Name = secondec2
```

---

# 4. timestamp Function

## Syntax

```hcl
timestamp()
```

Returns the current UTC timestamp.

Example:

```hcl
timestamp()
```

Output:

```
2026-07-07T17:05:14Z
```

---

# 5. formatdate Function

## Syntax

```hcl
formatdate(format, timestamp)
```

Converts a timestamp into a readable date format.

---

## Example

```hcl
formatdate(
 "DD MMM YYYY hh:mm ZZZ",
 timestamp()
)
```

Output:

```
07 Jul 2026 17:06 UTC
```

---

## Decoding Terraform Code

```hcl
CreationDate = formatdate(
 "DD MMM YYYY hh:mm ZZZ",
 timestamp()
)
```

Example EC2 Tag:

```
CreationDate = 07 Jul 2026 17:06 UTC
```

Terraform automatically adds the instance creation date as a tag.

---

# Complete Function Flow

```
variable tags
      |
      v
length(var.tags)
      |
      v
count creates EC2 instances


variable ami map
      |
      v
lookup(var.ami,var.region)
      |
      v
select correct AMI


count.index
      |
      v
element(var.tags,count.index)
      |
      v
assign EC2 Name tag


timestamp()
      |
      v
formatdate()
      |
      v
CreationDate tag
```

---

# Summary

| Function | Purpose |
|----------|---------|
| lookup() | Retrieves value from a map using a key |
| length() | Returns number of items/characters |
| element() | Retrieves an item from a list |
| timestamp() | Returns current UTC time |
| formatdate() | Formats timestamp into readable date |
