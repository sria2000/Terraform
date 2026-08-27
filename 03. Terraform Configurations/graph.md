# Terraform Graph

## What is `terraform graph`?

`terraform graph` generates a **visual representation of the dependency relationships** between resources defined in your Terraform configuration.

It outputs the dependency graph in **DOT format**, which can be visualized using **Graphviz** or an online Graphviz viewer.

This is useful for understanding:

- Resource dependencies
- Resource creation order
- Infrastructure architecture
- Troubleshooting dependency issues

---

## Documentation

HashiCorp Documentation:

https://developer.hashicorp.com/terraform/cli/commands/graph

---

## Graphviz Online Viewer

You can paste the output of `terraform graph` into the following website to visualize the graph:

https://dreampuf.github.io/GraphvizOnline/

---

# Example 1 - AWS Resources

```hcl
resource "aws_eip" "lb" {
  domain = "vpc"
}

resource "aws_security_group" "example" {
  name = "attribute-sg"
}

resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = aws_security_group.example.id

  cidr_ipv4   = "${aws_eip.lb.public_ip}/32"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_instance" "web" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
}
```

### Dependency Relationships

```text
aws_eip.lb
      │
      ▼
aws_vpc_security_group_ingress_rule.example
      ▲
      │
aws_security_group.example

aws_instance.web
(No dependency)
```

Terraform automatically detects these dependencies because the ingress rule references:

- `aws_security_group.example.id`
- `aws_eip.lb.public_ip`

---

# Example 2 - Local File Resources

```hcl
resource "local_file" "foo" {
  content  = "Hello from Sri!"
  filename = "${path.module}/Sri.txt"
}
```

Running:

```bash
terraform graph
```

Example output:

```text
digraph G {
  rankdir = "RL";
  node [shape = rect, fontname = "sans-serif"];

  "local_file.foo" [label="local_file.foo"];
  "local_file.fooo" [label="local_file.fooo"];
  "local_file.json_example" [label="local_file.json_example"];
}
```

Since these resources do not reference one another, there are **no dependency arrows** between them.

---

# Commands Used

Generate the dependency graph:

```bash
terraform graph
```

Install Graphviz (Linux):

```bash
sudo apt install graphviz
```

Generate an SVG image:

```bash
terraform graph | dot -Tsvg > graph.svg
```

Generate a PNG image:

```bash
terraform graph | dot -Tpng > graph.png
```

---

# Using Graphviz Online

1. Run:

   ```bash
   terraform graph
   ```

2. Copy the entire output.

3. Open:

   https://dreampuf.github.io/GraphvizOnline/

4. Paste the output into the editor.

5. The website automatically generates a graphical view of your Terraform dependency graph.

---

# Why Use `terraform graph`?

- Understand resource dependencies.
- Visualize the infrastructure architecture.
- Debug dependency-related issues.
- Verify the order in which Terraform creates resources.
- Learn how Terraform builds the dependency graph automatically.

---

# Key Points

- `terraform graph` generates a dependency graph in **DOT format**.
- The output can be viewed using **Graphviz** or an online Graphviz viewer.
- Terraform automatically detects dependencies based on resource references.
- Resources without dependencies appear as standalone nodes.
- Graphs are useful for debugging, learning, and documenting Terraform infrastructure.
