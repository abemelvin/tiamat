from django.shortcuts import render
from django.http import HttpResponse, Http404
from django.shortcuts import render, redirect, get_object_or_404
from django.core.urlresolvers import reverse
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.contrib.auth import login, authenticate
from django.db import transaction
from django.contrib import messages
from django.core import serializers
from django.views.decorators.csrf import ensure_csrf_cookie
from django.contrib.auth.tokens import default_token_generator
from django.core.mail import send_mail

from sqlinject.models import Order
from sqlinject.forms import RegistrationForm, UserForm

from datetime import datetime
import time


from django.db import connection
# Create your views here.

from collections import namedtuple

def namedtuplefetchall(cursor):
    "Return all rows from a cursor as a namedtuple"
    desc = cursor.description
    nt_result = namedtuple('Result', [col[0] for col in desc])
    return [nt_result(*row) for row in cursor.fetchall()]

@login_required
def query(request):
    context = {}
    # Case: query
    if request.method == "POST":
        if "tag_order" in request.POST:
            with connection.cursor() as cursor:
                query = 'SELECT sqo.id, sqo.date, sqo.content, user.first_name, user.last_name FROM sqlinject_order AS sqo INNER JOIN auth_user AS user ON sqo.owner_id=user.id WHERE owner_id = \'%s\' AND content LIKE \'%%%s%%\'' % (str(request.user.id), str(request.POST['sql_query_order']))
                cursor.execute(query)
                orders = namedtuplefetchall(cursor)
                context = {'orders': orders}
            return render(request, 'sqlinject/list.html', context)
        elif "tag_user" in request.POST:
            with connection.cursor() as cursor:
                query = 'SELECT user.first_name, user.last_name, user.email, sg.group_type FROM auth_user AS user INNER JOIN sqlinject_group AS sg ON user.id=sg.user_id WHERE first_name LIKE \'%%%s%%\' AND last_name LIKE \'%%%s%%\'' % (str(request.POST['sql_query_first_name']),str(request.POST['sql_query_last_name']))
                cursor.execute(query)
                users = namedtuplefetchall(cursor)
                context = {'users': users}
            return render(request, 'sqlinject/list.html', context)
    else:
        context = {'orders': []}
        return render(request, 'sqlinject/search.html', context)

@transaction.atomic
def register(request):
    context = {}

    # Just display the registration form if this is a GET request.
    if request.method == 'GET':
        context['form'] = RegistrationForm()
        return render(request, 'sqlinject/register.html', context)

    # Creates a bound form from the request POST parameters and makes the 
    # form available in the request context dictionary.
    form = RegistrationForm(request.POST)
    context['form'] = form

    # Validates the form.
    if not form.is_valid():
        return render(request, 'sqlinject/register.html', context)

    # At this point, the form data is valid.  Register and login the user.
    new_user = User.objects.create_user(username=form.cleaned_data['username'], 
                                        password=form.cleaned_data['password1'],
                                        email=form.cleaned_data['email'],
                                        first_name=form.cleaned_data['first_name'],
                                        last_name=form.cleaned_data['last_name'])
    new_user.save()

    # Logs in the new user and redirects to his/her todo list
    new_user = authenticate(username=form.cleaned_data['username'],
                            password=form.cleaned_data['password1'])
    login(request, new_user)
    return redirect(reverse('home'))


