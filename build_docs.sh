set -e
mkdir -p standard/docs/field_definitions
python standard/schema/utils/make_field_definitions.py
cd standard
sphinx-build -b dirhtml docs ../build/en
sphinx-build -b gettext docs ../build/locale
sphinx-intl -c docs/conf.py update -p ../build/locale -l es
sphinx-build -b dirhtml -D language='es' . ../build/es
cd ..
cp -r standard/assets build
cp standard/schema/*.json build/en/
