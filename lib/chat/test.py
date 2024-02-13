def main():
    ...

def calc_res(first_user_input, result):
  if first_user_input>0 and first_user_input<=100:
      if result!='':
        result= result+'\n'+str(calc_sum(int(input()),input(),0))
      else:
         result= result+str(calc_sum(int(input()),input(),0))
      first_user_input=first_user_input-1
      return calc_res(first_user_input, result)
  else: return result
    
def calc_sum(num_amount,nums,sum):
    if(num_amount-1>=0 and num_amount-1<=99):
      if(int(nums.split()[num_amount-1])>0 and int(nums.split()[num_amount-1])<=100):
       sum= int(nums.split()[num_amount-1])**2+sum
      return calc_sum(num_amount-1,nums,sum)
    else: 
       return sum
     
print(calc_res(int(input()),''))

if __name__ == "__main__":
    main()