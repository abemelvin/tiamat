from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.html import escape
from django.utils.translation import ugettext_lazy as _

from django.db.models.signals import post_save
from django.dispatch import receiver
import os

class Order(models.Model):
    # user = models.ForeignKey(User)
    date = models.DateTimeField(auto_now_add=True)
    content = models.TextField(max_length=160)
    owner = models.ForeignKey(User, related_name="order_owner")

class Group(models.Model):
    GROUP_TYPES = (
        ('A', 'Administrator'),
        ('M', 'Manager'),
        ('P', 'Premium'),
        ('N', 'Normal'),
        ('G', 'Guest'),
    )   
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="group_user")
    group_type = models.TextField(max_length=30, default="G", choices=GROUP_TYPES)



@receiver(post_save, sender=User)
def create_group(sender, instance, created, **kwargs):
    if created:
        Group.objects.create(user=instance)

@receiver(post_save, sender=User)
def save_group(sender, instance, **kwargs):
    instance.group_user.save()