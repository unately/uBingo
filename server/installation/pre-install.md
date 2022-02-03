---
description: Here you can see how to install the prerequisites
---

# 🦜 Pre-Install

## Java >17 <a href="#java-17" id="java-17"></a>

{% tabs %}
{% tab title="Windows" %}
### On Windows

For windows based systems.

1. Open the [Adoptium](https://adoptium.net) page and select **version 17** _(if you don't see version 17 you can also use **version 18**)._
2. Download the exe file by clicking on the _**Latest release** button._
3. Execute the downloaded file and click through the installer.

{% hint style="warning" %}
💡 **Don't forget to choose during installation to set the JAVA\_HOME variable!**
{% endhint %}
{% endtab %}

{% tab title="Linux" %}
### **On Linux**

For all systems running on Linux

#### **Ubuntu/Debian**

```bash
sudo apt-get update
sudo apt-get install openjdk-17-jdk
```

#### **CentOS**

```bash
sudo yum install java-11-openjdk
```
{% endtab %}
{% endtabs %}

## Only for Linux: Curl

If curl for whatever reason isn't installed you can see here how to install it.

#### **Ubuntu/Debian**

```bash
sudo apt-get update
sudo alt-get curl
```
