# frozen_string_literal: true

# rubocop:disable ModuleLength
module MedicationsHelper
  include FormHelper

  def new_medication_props
    new_form_props(medication_form_inputs, medications_path)
  end

  def edit_medication_props
    edit_form_props(medication_form_inputs, medication_path(@medication))
  end

  private

  def medication_form_inputs
    current_user.google_oauth2_enabled? ? google_fields : common_fields
  end

  # rubocop:disable MethodLength
  def common_fields
    [
      {
        id: 'medication_name',
        type: 'text',
        name: 'medication[name]',
        label: t('common.name'),
        value: @medication.name || nil,
        required: true,
        info: t('categories.form.name_hint'),
        dark: true
      },
      medication_field('strength'),
      {
        id: 'medication_strength_unit',
        type: 'select',
        name: 'medication[strength_unit]',
        value: @medication.strength_unit || t('medications.units.mg'),
        dark: true,
        options: [
          {
            id: 'medication_strength_unit_mg',
            label: t('medications.units.mg'),
            value: t('medications.units.mg')
          },
          {
            id: 'medication_strength_unit_ml',
            label: t('medications.units.ml'),
            value: t('medications.units.ml')
          }
        ]
      },
      medication_field('total'),
      medication_unit_field('total'),
      medication_field('dosage'),
      medication_unit_field('dosage'),
      {
        id: 'medication_refill',
        type: 'date',
        name: 'medication[refill]',
        label: t('medications.form.refill'),
        value: @medication.refill || nil,
        info: t('medications.form.refill_hint'),
        required: true,
        dark: true
      },
      {
        id: 'medication_comments',
        type: 'textarea',
        name: 'medication[comments]',
        label: t('comment.plural'),
        value: @medication.comments || nil,
        info: t('medications.form.comments_hint'),
        dark: true
      },
      {
        id: 'medication_refill_reminder',
        type: 'checkbox',
        dark: true,
        label: t('medications.refill_reminder'),
        info: t('medications.form.refill_reminder_hint'),
        name: 'medication[refill_reminder_attributes][active]',
        checked: @medication&.refill_reminder&.active,
        uncheckedValue: false,
        value: true
      },
      {
        id: 'medication_take_medication_reminder',
        type: 'checkbox',
        dark: true,
        label: t('common.daily_reminder'),
        info: t('medications.form.daily_reminder_hint'),
        name: 'medication[take_medication_reminder_attributes][active]',
        checked: @medication&.take_medication_reminder&.active,
        uncheckedValue: false,
        value: true
      },
      {
        id: 'medication_refill_reminder_attributes_id',
        name: 'medication[refill_reminder_attributes][id]',
        type: 'hidden',
        value: @medication&.refill_reminder&.id
      },
      {
        id: 'medication_take_medication_reminder_attributes_id',
        name: 'medication[take_medication_reminder_attributes][id]',
        type: 'hidden',
        value: @medication&.take_medication_reminder&.id
      }
    ]
  end
  # rubocop:enable MethodLength

  # rubocop:disable MethodLength
  def google_fields
    common_fields.push(
      id: 'medication_add_to_google_cal',
      type: 'checkbox',
      dark: true,
      label: t('medications.form.add_to_google_cal'),
      info: t('medications.form.google_cal_hint'),
      name: 'medication[add_to_google_cal]',
      checked: @medication.add_to_google_cal,
      uncheckedValue: false,
      value: true
    )
  end
  # rubocop:enable MethodLength

  # rubocop:disable MethodLength
  def days_checkbox
    week_days = 0.upto(6)
    week_days.map do |i|
      {
        id: "medication_weekly_dosage_#{i}",
        type: 'checkbox',
        name: 'medication[weekly_dosage][]',
        label: t(:'date.abbr_day_names')[i],
        checked: @medication.weekly_dosage.include?(i),
        value: i
      }
    end
  end
  # rubocop:enable MethodLength

  # rubocop:disable MethodLength
  def medication_unit_field(type)
    {
      id: "medication_#{type}_unit",
      type: 'select',
      name: "medication[#{type}_unit]",
      dark: true,
      value: @medication["#{type}_unit"] ||
        t('medications.units.tablets.other'),
      options: [
        {
          id: "medication_#{type}_unit_tablets",
          label: t('medications.units.tablets.other'),
          value: t('medications.units.tablets.other')
        },
        {
          id: "medication_#{type}_unit_mg",
          label: t('medications.units.mg'),
          value: t('medications.units.mg')
        },
        {
          id: "medication_#{type}_unit_ml",
          label: t('medications.units.ml'),
          value: t('medications.units.ml')
        }
      ]
    }
  end
  # rubocop:enable MethodLength

  # rubocop:disable MethodLength
  def medication_field(type)
    {
      id: "medication_#{type}",
      type: 'number',
      name: "medication[#{type}]",
      label: t("medications.form.#{type}"),
      value: @medication[type.to_s] || nil,
      required: true,
      info: t("medications.form.#{type}_hint"),
      placeholder: t("medications.form.#{type}_placeholder"),
      dark: true
    }
  end
  # rubocop:enable MethodLength
end
# rubocop:enable ModuleLength
